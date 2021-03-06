//
//  MainController.m
//  Cauldron
//
//  Created by John Nik on 5/7/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "MainController.h"
#import "MenuCell.h"
#import "RegisterViewController.h"
#import "RosterVC.h"
#import "AttendanceVC.h"
#import "CategoryViewController.h"
#import "ChallengeListViewController.h"
#import "TeamProfileTableViewController.h"
#import "ReportsController.h"
#import "PercentProgressCustomView.h"
#import "FinalRankingReportVC.h"
#import "CoachListController.h"

@interface MainController () {
    
    PercentProgressCustomView *percentProgressView;
    
    NSArray *menuTitleArr;
    NSArray *menuIconStringArr;
    float cellHeight;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

#define KEYVALUE                @"serverSyncProgressValue"
#define PROGRESS_VALUE          @"ProgressValue"
#define TOTAL_VALUE             @"totalValue"
typedef void(^myCompletion)(BOOL);

static NSString *simpleMenuTableIdentifier = @"MenuCell";

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self setMenuTitleAndIconArr];
    
    

    
    if (Global.mode == USER_MODE_INDIVIDUAL || Global.mode == USER_MODE_PLAYER) {
        Global.currentTeamId = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"MASTERTEAMID"];
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM TeamInfo WHERE TeamID = %d", Global.currentTeamId];
        NSArray *records = [SCSQLite selectRowSQL:query];
        
        NSLog(@"teamrecords, %@", records);
        if ([records count] != 0)
            Global.currntTeam = [DataFetcherHelper getCurrentTeamDataFromDict: [records objectAtIndex:0]];
        
        if (Global.currntTeam.isSubscribe != 1) {
            if (Global.mode == USER_MODE_INDIVIDUAL) {
                [self showAlertSubsciptionEnd];
            }
            
        }
    }
    
    [Global loadUserProfileDataInLocal];
    
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:simpleMenuTableIdentifier];
    } else {
        [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell_iPad" bundle:nil] forCellReuseIdentifier:simpleMenuTableIdentifier];
    }
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    percentProgressView = [[PercentProgressCustomView alloc] initWithFrame:self.view.frame];
    
    UIView *keywindow = [UIApplication sharedApplication].keyWindow;
    [keywindow addSubview:percentProgressView];
    //    [self.view bringSubviewToFront:percentProgressView];
    
    [percentProgressView setHidden:YES];
    
}



- (void)showAlertSubsciptionEnd {
    [Alert showOKCancelAlert:@"Subsciption End" message:@"Do you want to postpone Subsciption?" viewController:self complete:^{
        
        NSLog(@"Navigating to website--http://competitive-cauldron.com/stats");
        
        NSString *urlStr = @"http://competitive-cauldron.com/stats";
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: urlStr]];
        
        
        
    } canceled:^{
        NSLog(@"Canceled Subsciption end");
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    [self addMenuBarButtomItem];
    [self setiPhoneAndiPadUI];
}

- (void)setiPhoneAndiPadUI {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        cellHeight = 38.0;
        
    } else {
        
        cellHeight = 76;
        
    }
    
}

- (void)setMenuTitleAndIconArr {
    
    
    if (Global.mode == USER_MODE_DEMO) {
        
//        menuTitleArr = @[@"Edit Profile", @"Roster", @"Attendence", @"Rankings", @"Final Ranking Report", @"Add stats", @"Journals", @"Reports", @"Challenges", @"Challenge Category", @"Update Data", @"Synchronize"];
//        menuIconStringArr = @[@"edit_profile", @"players", @"attendence", @"ranking", @"final_ranking", @"add_stats", @"newspaper", @"report", @"challenge_subcategory", @"callengeCategory", @"update", @"synchronize"];
        
        menuTitleArr = @[@"Edit Profile", @"Roster", @"Attendence", @"Rankings", @"Final Ranking Report", @"Add stats", @"Journals", @"Reports", @"Update Data", @"Synchronize"];
        menuIconStringArr = @[@"edit_profile", @"players", @"attendence", @"ranking", @"final_ranking", @"add_stats", @"newspaper", @"report", @"update", @"synchronize"];
        
    } else if (Global.mode == USER_MODE_CLUB) {
//        menuTitleArr = @[@"Edit Profile", @"Coach List", @"Roster", @"Attendence", @"Rankings", @"Final Ranking Report", @"Add stats", @"Journals", @"Reports", @"Challenges", @"Challenge Category", @"Update Data", @"Synchronize"];
//        menuIconStringArr = @[@"edit_profile", @"coach_list", @"players", @"attendence", @"ranking", @"final_ranking", @"add_stats", @"newspaper", @"report", @"challenge_subcategory", @"callengeCategory", @"update", @"synchronize"];
        
        menuTitleArr = @[@"Edit Profile", @"Coach List", @"Roster", @"Attendence", @"Rankings", @"Final Ranking Report", @"Add stats", @"Journals", @"Reports", @"Update Data", @"Synchronize"];
        menuIconStringArr = @[@"edit_profile", @"coach_list", @"players", @"attendence", @"ranking", @"final_ranking", @"add_stats", @"newspaper", @"report", @"update", @"synchronize"];

        
    } else if (Global.mode == USER_MODE_INDIVIDUAL || Global.mode == USER_MODE_COACH) {
//        menuTitleArr = @[@"Edit Profile", @"Roster", @"Attendence", @"Rankings", @"Final Ranking Report", @"Add stats", @"Journals", @"Reports", @"Challenges", @"Challenge Category", @"Update Data", @"Synchronize"];
//        menuIconStringArr = @[@"edit_profile", @"players", @"attendence", @"ranking", @"final_ranking", @"add_stats", @"newspaper", @"report", @"challenge_subcategory", @"callengeCategory", @"update", @"synchronize"];
        
        menuTitleArr = @[@"Edit Profile", @"Roster", @"Attendence", @"Rankings", @"Final Ranking Report", @"Add stats", @"Journals", @"Reports", @"Update Data", @"Synchronize"];
        menuIconStringArr = @[@"edit_profile", @"players", @"attendence", @"ranking", @"final_ranking", @"add_stats", @"newspaper", @"report", @"update", @"synchronize"];
    }
    else if (Global.mode == USER_MODE_PLAYER) {
        menuTitleArr = @[@"Rankings", @"Journals", @"Reports", @"Final Ranking Report", @"Update Data"];
        menuIconStringArr = @[@"ranking", @"newspaper", @"report", @"final_ranking", @"update"];
    }

    
//    if (Global.mode == 5) {
//        
//        menuTitleArr = @[@"Edit Profile", @"Coach List", @"Roster", @"Attendence", @"Ranking", @"Add stats", @"Journal", @"Att.Report", @"Challenge Category", @"Challenge SubCategory", @"Update Data", @"Synchronize", @"Logout"];
//        menuIconStringArr = @[@"edit_profile", @"coach_list", @"roster", @"attendence", @"ranking", @"add_stats", @"journal", @"report", @"challenge_category", @"challenge_subcategory", @"update", @"synchronize", @"logout"];
//        
//    } else if (Global.mode == USER_MODE_CLUB || Global.mode == USER_MODE_COACH || Global.mode == USER_MODE_INDIVIDUAL) {
//        menuTitleArr = @[@"Edit Profile", @"Roster", @"Attendence", @"Ranking", @"Add stats", @"Journal", @"Att.Report", @"Challenge Category", @"Challenge SubCategory", @"Update Data", @"Synchronize", @"Logout"];
//        menuIconStringArr = @[@"edit_profile", @"roster", @"attendence", @"ranking", @"add_stats", @"journal", @"report", @"challenge_category", @"challenge_subcategory", @"update", @"synchronize", @"logout"];
//    } else if (Global.mode == USER_MODE_PLAYER) {
//        menuTitleArr = @[@"Ranking", @"Journal", @"Att.Report", @"Update Data", @"Synchronize", @"Logout"];
//        menuIconStringArr = @[@"ranking", @"journal", @"report", @"update", @"synchronize", @"logout"];
//    }
    
    
}

- (IBAction)didTapEdit:(id)sender {
    
    TeamProfileTableViewController *teamProfileTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeamProfileTableViewController"];
    teamProfileTableViewController.navigationTeamStatus = TeamState_Update;
    [self.navigationController pushViewController:teamProfileTableViewController animated:true];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menuTitleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:simpleMenuTableIdentifier];
    
    cell.menuLabel.text = menuTitleArr[indexPath.row];
    cell.menuImageView.image = [UIImage imageNamed:menuIconStringArr[indexPath.row]];
    
    if ([cell.menuLabel.text  isEqual: @"Synchronize"]) {
        cell.syncCountLabel.text = String(Global.syncCount);
    } else {
        cell.syncCountLabel.text = @"";
    }
    
    return cell;

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *item = menuTitleArr[indexPath.row];
    
    if ([item isEqualToString:@"Edit Profile"]) {
        
        
        RegisterViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
        viewController.navigationStatus = RegisterState_Update;
        
        [self.navigationController pushViewController:viewController animated:YES];
        
        
    } else if ([item isEqualToString:@"Roster"]) {
        
        RosterVC *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RosterVC"];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if ([item isEqualToString:@"Attendence"]) {
        
        AttendanceVC *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AttendanceVC"];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if ([item isEqualToString:@"Rankings"]) {
        
        [self showChallangesOrRanking:NavigationStateRanking];
        
    } else if ([item isEqualToString:@"Final Ranking Report"]) {
        
        FinalRankingReportVC *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FinalRankingReportVC"];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if ([item isEqualToString:@"Add stats"]) {
        
        [self showChallangesOrRanking:NavigationStateChallenge];
        
    } else if ([item isEqualToString:@"Journals"]) {
        
        JournalVC *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"JournalVC"];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if ([item isEqualToString:@"Reports"]) {
        ReportsController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReportsController"];
        [self.navigationController pushViewController:viewController animated:YES];

        
    } else if ([item isEqualToString:@"Challenge Category"]) {
        
        CategoryViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryVC"];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if ([item isEqualToString:@"Challenges"]) {
        
        ChallengeListViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditChallengeViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if ([item isEqualToString:@"Update Data"]) {
        
        [self update];
        
    } else if ([item isEqualToString:@"Synchronize"]) {
        
        [self sync];
        
    } else if ([item isEqualToString:@"Logout"]) {
        
        [self logout];
        
    } else if ([item isEqualToString:@"Coach List"]) {
        CoachListController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CoachListController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }

    
}

- (void)showChallangesOrRanking:(NavigationStatus)status {
    
    ChallangesVC *viewController = (ChallangesVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ChallangesVC"];
    viewController.status = status;
    
    viewController.userTeamID = Global.currntTeam.TeamID;
    
    int teamSportID = (int)[Global.currntTeam.Sport intValue];
    
    viewController.soportsID = teamSportID;
    
    [self.navigationController pushViewController:viewController animated:YES];
}




- (void)addMenuBarButtomItem {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor blueColor];
    [containerView setTranslatesAutoresizingMaskIntoConstraints:false];
    [titleView addSubview:containerView];
    
    UIImageView *teamImageView = [[UIImageView alloc] init];
    teamImageView.contentMode = UIViewContentModeScaleToFill;
    teamImageView.layer.cornerRadius = 20;
    teamImageView.layer.masksToBounds = YES;
    
    UILabel *teamNameLabel = [[UILabel alloc] init];
    NSString *teamName = Global.currntTeam.Team_Name;
    teamNameLabel.text = teamName;
    [teamNameLabel setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [containerView addSubview:teamNameLabel];
    
    int nameCharacCount = (int)[teamName length];
    
    if (Global.currntTeam.Team_Picture && ![Global.currntTeam.Team_Picture isEqualToString:@""]) {
        teamImageView.image = [UIImage imageWithData:[Global.currntTeam.Team_Picture base64Data]];
        
        teamImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:teamImageView];
        [[teamImageView.leftAnchor constraintEqualToAnchor:containerView.leftAnchor] setActive:true];
        [[teamImageView.centerYAnchor constraintEqualToAnchor:containerView.centerYAnchor] setActive:true];
        [[teamImageView.widthAnchor constraintEqualToConstant:40] setActive:true];
        [[teamImageView.heightAnchor constraintEqualToConstant:40] setActive:true];
        
        [[teamNameLabel.leftAnchor constraintEqualToAnchor:teamImageView.rightAnchor constant:8] setActive:true];
        
        if (nameCharacCount > 16 && [[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
            [[teamNameLabel.widthAnchor constraintEqualToConstant:140] setActive:true];
            [[teamNameLabel.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor constant:24] setActive: true];
            
        } else {
            
            [[teamNameLabel.rightAnchor constraintEqualToAnchor:containerView.rightAnchor] setActive:true];
        }
    } else {
        [[teamNameLabel.leftAnchor constraintEqualToAnchor:containerView.leftAnchor constant:0] setActive:true];
        
        if (nameCharacCount > 21 && [[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
            [[teamNameLabel.widthAnchor constraintEqualToConstant:180] setActive:true];
            [[teamNameLabel.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor] setActive: true];
            
        } else {
            
            [[teamNameLabel.rightAnchor constraintEqualToAnchor:containerView.rightAnchor] setActive:true];
        }
    }
    
    
    
    [[teamNameLabel.centerYAnchor constraintEqualToAnchor:containerView.centerYAnchor] setActive:true];
    [[teamNameLabel.heightAnchor constraintEqualToConstant:40] setActive:true];
    
    
    
    
    
    [[containerView.centerXAnchor constraintEqualToAnchor:titleView.centerXAnchor] setActive:true];
    [[containerView.centerYAnchor constraintEqualToAnchor:titleView.centerYAnchor] setActive:true];
    
    self.navigationItem.titleView = titleView;
    
    if (Global.mode == 5) {
        
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Teams" style:UIBarButtonItemStylePlain target:self action:@selector(goingBackTeams)];
        self.navigationItem.leftBarButtonItem = leftButton;
        
    } else if (Global.mode == USER_MODE_CLUB || Global.mode == USER_MODE_COACH) {
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Teams" style:UIBarButtonItemStylePlain target:self action:@selector(goingBackTeams)];
        self.navigationItem.leftBarButtonItem = leftButton;
    } else if (Global.mode == USER_MODE_INDIVIDUAL) {
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Logoff" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
        self.navigationItem.leftBarButtonItem = leftButton;    }
    else if (Global.mode == USER_MODE_PLAYER) {
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Logoff" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit Team" style:UIBarButtonItemStylePlain target:self action:@selector(didTapEdit:)];
    self.navigationItem.rightBarButtonItem = rightButton;

    if (Global.mode == USER_MODE_INDIVIDUAL) {
//        self.navigationItem.leftBarButtonItem = nil;
    } else if (Global.mode == USER_MODE_PLAYER) {
//        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}

- (void)goingBackTeams {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)sync {
    // Check more data available for sync
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM ChallangeStat WHERE Sync=%d",1];
    NSArray *teamPlayersStats = [SCSQLite selectRowSQL:query];
    
    
    NSString *queryAttandance = [NSString stringWithFormat:@"SELECT * FROM playerattendance WHERE sync=%d",1];
    NSArray *playersAttandace = [SCSQLite selectRowSQL:queryAttandance];
    
    NSString *queryJournal = [NSString stringWithFormat:@"SELECT * FROM JournalData WHERE sync=%d",1];
    NSArray *playersJournal = [SCSQLite selectRowSQL:queryJournal];
    
    NSString *queryPlayer = [NSString stringWithFormat:@"SELECT * FROM PlayersInfo WHERE Sync=%d",1];
    NSArray *playersData = [SCSQLite selectRowSQL:queryPlayer];
    
    if (teamPlayersStats.count > 0 || playersAttandace.count > 0 || playersJournal.count > 0 || playersData.count> 0) {
        NSString *message = @"Are You Sure Want To Sync All Data To Server, Require High Speed Internet Connection" ;
        [Alert showOKCancelAlert:@"Sync Data!" message:message viewController:self complete:^{
            [self syncData];
        } canceled:^{
        }];
    } else {
        [Alert showAlert:@"No Data" message:@"There is no more data to sync." viewController:self];
    }
}

- (void) update {
    NSString *message = @"Are You Sure Want To Update All Data?, This May Take Few Minutes And Require High Speed Internet Connection";
    [Alert showOKCancelAlert:@"Update Data!" message:message viewController:self complete:^{
        [self updateData];
    } canceled:^{
    }];
}

static int syncMode = 0;

- (void) syncData {
    syncMode = 0;
    
    // check internet connection
    BOOL checkConnection = [RKCommon checkInternetConnection];
    if (!checkConnection) {
        [Alert showAlert:@"Internet Connection Error" message:@"" viewController:self];
        return;
    }
    
    [ProgressHudHelper showLoadingHudWithText:@"Uploading Data..."];
    
//    [percentProgressView showProgress];
    
    SyncToServer  *syncToServer = [[SyncToServer alloc]init];
    syncToServer.delegate = self;
    [syncToServer startSyncDataToServer];
}

- (void) updateData {
    syncMode = 1;
    
    // check internet connection
    BOOL checkConnection = [RKCommon checkInternetConnection];
    if (!checkConnection) {
        [Alert showAlert:@"Internet Connection Error" message:@"" viewController:self];
        return;
    }
    
    // check more data available for sync
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM ChallangeStat WHERE Sync=%d",1];
    NSArray *teamPlayersStats = [SCSQLite selectRowSQL:query];
    
    [ProgressHudHelper showLoadingHudWithText:@"Updating...."];
    
    SyncFromServer *syncFromServer = [[SyncFromServer alloc] init];
    syncFromServer.delegate = self;
    if (Global.mode == USER_MODE_CLUB  || Global.mode == USER_MODE_COACH) {
        int cnt = (int)Global.arrTeamsId.count;
        for (int i = 0; i < cnt; i++) {
            NSInteger teamId = [[Global.arrTeamsId objectAtIndex:i] integerValue];
            [syncFromServer startSyncFromServerWithDataDict:nil serviceType:@"startSync" WithTeamID:(int)teamId syncCount:cnt playerID:(int)[Global.playerIDFinal intValue] mode:Global.mode];
        }
        
    } else {
        [syncFromServer startSyncFromServerWithDataDict:nil serviceType:@"startSync" WithTeamID:Global.currntTeam.TeamID syncCount:1 playerID:(int)[Global.playerIDFinal intValue] mode:Global.mode];
    }
}

#pragma Delegate Sync To Server

- (void) SyncToServerProcessCompleted {
    
    Global.syncCount = 0;
    [[NSUserDefaults standardUserDefaults] setInteger:Global.syncCount forKey:@"SYNCCOUNT"];
    [self.tableView reloadData];
    
    [Global.attendenceDateArr removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:Global.attendenceDateArr forKey:@"ATTENDENCEDATEARR"];
    [ProgressHudHelper hideLoadingHud];
    
    [Alert showAlert:@"Sync Completed!" message:@"All Data Sync Successfully" viewController:self];
    
}


#pragma Selegate Sync From Server

- (void) syncFromServerProcessCompleted {
//    [ProgressHudHelper hideLoadingHud];
    
    
    
    if (syncMode == 0) {
        NSLog(@"All Sync Process Complete From SERVER For UPDATE");
        // Save updated date to UserDefault
        NSString *lastSyncDate = [NSString stringWithFormat:@"Last Updated:%@",[RKCommon getSyncDateInString]];
        [UserDefaults setObject:lastSyncDate forKey:@"LASTSYNCDATE"];
        [UserDefaults synchronize];
    } else {
        NSLog(@"All Sync Process Complete From SERVER");
    }
    NSLog(@"startDelay");
    


    [self myMethod:^(BOOL finished) {
            if(finished){
                NSLog(@"success");
                [Alert showAlert:@"Sync Completed!" message:@"All Data Sync Successfully" viewController:self];
            }
        }];
    
    
}

-(void) myMethod:(myCompletion) compblock{
    //do stuff
    [ProgressHudHelper hideLoadingHud];
    
    compblock(YES);
}

-(void)showAlert {
    
    NSLog(@"endDelay");
    [Alert showAlert:@"Sync Completed!" message:@"All Data Sync Successfully" viewController:self];
}

- (int) getTeamId {
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    //???
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM TeamInfo WHERE admin_name ='%@' AND admin_pw ='%@'",[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERID"],[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERPASS"]];
    NSArray *recordsFound = [SCSQLite selectRowSQL:query];
    
    if (recordsFound.count > 0) {
        NSLog(@"Found Record Details : %@",recordsFound);
        
        if ([[recordsFound objectAtIndex:0]valueForKey:@"Teams"]) {
            NSString *totalTeam=[[recordsFound objectAtIndex:0]valueForKey:@"Teams"];
            if (![totalTeam isEqualToString:@""]) {
                NSError *error = nil;
                NSDictionary *dict = [XMLReader dictionaryForXMLString:totalTeam options:XMLReaderOptionsProcessNamespaces error:&error];
            }
        }
        
        return [recordsFound[0][@"TeamID"] intValue];
    }
    
    return 0;
}



- (void)logout {
    
    [Alert showOKCancelAlert:@"Are you sure you want to logoff?" message:@"" viewController:self complete:^{
        UINavigationController *nav = [self.storyboard instantiateInitialViewController];
        [UserDefaults removeObjectForKey:@"ISLOGIN"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERID"] forKey:@"ONLINE_PREVIOUS_LOG_USERNAME"];
        [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERPASS"] forKey:@"ONLINE_PREVIOUS_LOG_PASSWORD"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERID"] forKey:@"finalID"];
        [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERPASS"] forKey:@"finalPass"];
        
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SAVEDUSERID"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SAVEDUSERPASS"];
        //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CHECKBOXSTAT"];
        //    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"finalID"];
        //    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"finalPass"];
        
        //    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"CHECKBOXSTATSTR"];
        Global.syncCount = 0;
        [[NSUserDefaults standardUserDefaults] setInteger:Global.syncCount forKey:@"SYNCCOUNT"];
        
        [Global.attendenceDateArr removeAllObjects];
        [[NSUserDefaults standardUserDefaults] setObject:Global.attendenceDateArr forKey:@"ATTENDENCEDATEARR"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        ApplicationDelegate.window.rootViewController = nav;
    } canceled:nil];
    
    
}

                               
                               







@end
