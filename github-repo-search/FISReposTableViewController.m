//
//  FISReposTableViewController.m
//  
//
//  Created by Joe Burgess on 5/5/14.
//
//

#import "FISReposTableViewController.h"
#import "FISReposDataStore.h"
#import "FISGithubRepository.h"

@interface FISReposTableViewController ()

- (IBAction)searchTapped:(id)sender;


@property (strong, nonatomic) FISReposDataStore *dataStore;

@end

@implementation FISReposTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.accessibilityLabel=@"Repo Table View";
    self.tableView.accessibilityIdentifier=@"Repo Table View";

    self.tableView.accessibilityIdentifier = @"Repo Table View";
    self.tableView.accessibilityLabel=@"Repo Table View";
    
    self.dataStore = [FISReposDataStore sharedDataStore];
    
    [self.dataStore getRepositoriesWithCompletion:^(BOOL success) {
        [self.tableView reloadData];
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataStore.repositories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicCell" forIndexPath:indexPath];

    FISGithubRepository *repo = self.dataStore.repositories[indexPath.row];
    cell.textLabel.text = repo.fullName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FISGithubRepository *repo = self.dataStore.repositories[indexPath.row];
    
    [self.dataStore toggleStarForRepo:repo CompletionBlock:^(BOOL toggle) {
        
        if (toggle)
        {
            NSLog(@"%@: Star toggled ON", repo.fullName);
            
            NSString *alertTitle = [NSString stringWithFormat:@"You just starred %@", repo.fullName];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertTitle delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
        }
        else
        {
            NSLog(@"%@: Star toggled OFF", repo.fullName);
            
            NSString *alertTitle = [NSString stringWithFormat:@"You just unstarred %@", repo.fullName];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertTitle delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
        }
    }];
}

- (IBAction)searchTapped:(id)sender
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Search"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *searchCriteria = alertController.textFields.firstObject;
                                   
                                   if ( [searchCriteria.text length] > 0 )
                                   {
                                       [self.dataStore searchForReposUsingCriteria:searchCriteria.text CompletionBlock:^(BOOL success) {
                                           [self.tableView reloadData];
                                       }];
                                       
                                       NSLog(@"OK action");
                                   }
                                   else
                                   {
                                       NSLog(@"Nothing entered");
                                   }
                               }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Enter search criteria", @"Search");
     }];

    [alertController addAction:cancelAction];
    [alertController addAction:okAction];

    [self presentViewController:alertController animated:YES completion:nil];

}

@end
