//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Taylor Wright-Sanson on 10/6/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *addToDoItemTextField;

@property (weak, nonatomic) IBOutlet UITableView *toDoListTableView;


@property NSMutableArray *todoListArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.todoListArray = [NSMutableArray arrayWithObjects:@"Sky Dive from Sears Tower", @"Eat Cake", @"Tickle a Dragon", @"Don't Panic", nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.todoListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toDoListCell" forIndexPath:indexPath];

    cell.textLabel.text = [self.todoListArray objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction)onAddButtonPressed:(id)sender {
    NSString *usersText = self.addToDoItemTextField.text;
    [self.todoListArray addObject:usersText];
    [self.toDoListTableView reloadData];
    self.addToDoItemTextField.text = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
