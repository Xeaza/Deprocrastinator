//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Taylor Wright-Sanson on 10/6/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addToDoItemTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *checkedIndexes;

@property NSMutableArray *todoListArray;

@end        // Update checkmarked buttson list

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.todoListArray = [NSMutableArray arrayWithObjects:@"Sky Dive from Sears Tower", @"Eat Cake", @"Tickle a Dragon", @"Don't Panic", nil];

    self.checkedIndexes = [NSMutableArray arrayWithCapacity:self.todoListArray.count];
    // Created array of 0s indicating that no cells have been selected (i.e. no checkmark added)
    for (int i = 0; i < self.todoListArray.count; i++)
    {
        [self.checkedIndexes addObject:[NSNumber numberWithBool:NO]];
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.todoListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toDoListCell" forIndexPath:indexPath];

    cell.textLabel.text = [self.todoListArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
   [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (cell.accessoryType == UITableViewCellAccessoryNone)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // Update checkmarked buttson list
        [self.checkedIndexes replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];

    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.checkedIndexes removeObject:indexPath];
        // Update checkmarked buttson list
        [self.checkedIndexes replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
    }
}

- (IBAction)onAddButtonPressed:(id)sender {
    NSString *usersText = self.addToDoItemTextField.text;
    [self.todoListArray addObject:usersText];
    [self.checkedIndexes addObject:[NSNumber numberWithBool:NO]];
    [self.tableView reloadData];


    self.addToDoItemTextField.text = nil;
    [self.addToDoItemTextField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
