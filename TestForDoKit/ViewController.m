//
//  ViewController.m
//  TestForDoKit
//
//  Created by Shane on 2020/6/11.
//  Copyright © 2020 Shane. All rights reserved.
//

#import "ViewController.h"

#import <DoraemonKit/DoraemonKit.h>
#import <FMDB/FMDB.h>
#import "Student.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UITextField *deleteTextField;
@property (weak, nonatomic) IBOutlet UITextField *updateTextField;

@end

@implementation ViewController
{
    FMDatabase *_db;
    NSMutableArray *_arrDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _arrDataSource = [NSMutableArray array];
    [self.listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    [[DoraemonManager shareInstance] installWithPid:@"84f719dfc21db6e21f27568b65ca55bb"];
    
    [self createDataBase];
    [self createTable];
    // 获取数据
    [self queryAction:nil];
}

#pragma mark - <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    Student *student = _arrDataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"id:%ld   name:%@ age:%ld score:%@", (long)student.studentID, student.name, (long)student.age, student.score];
    return cell;
}

#pragma mark - Click Envents
- (IBAction)insertAction:(UIButton *)sender {
    NSString *sql = @"insert into t_student (name, age) values (?, ?)";
    NSString *name = [NSString stringWithFormat:@"学生%d", arc4random() % 10];
    NSNumber *age = [NSNumber numberWithInt:arc4random_uniform(100)];
    [_db executeUpdate:sql, name, age];
    
    [self queryAction:nil];
}

- (IBAction)deleteAction:(UIButton *)sender {
    NSString *studentID = self.deleteTextField.text;
    NSString *sql = [NSString stringWithFormat:@"delete from t_student where id = %@", studentID];
    if (studentID.length == 0) {
        sql = @"delete from t_student";
    }
    [_db executeUpdate:sql];
    
    [self queryAction:nil];
}

- (IBAction)updateAction:(UIButton *)sender {
    Student *student = _arrDataSource.firstObject;
    if (!student) {
        return;
    }
    NSString *sql = [NSString stringWithFormat:@"update t_student set name = '学生%ld', score = %@ where id = %ld", (long)student.studentID, self.updateTextField.text, (long)student.studentID];
    [_db executeUpdate:sql, [NSNumber numberWithInt:2]];
    
    [self queryAction:nil];
}

- (IBAction)queryAction:(UIButton *)sender {
    [_arrDataSource removeAllObjects];
    NSString *sql = @"select id, name, age, score FROM t_student";
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        int studentID = [rs intForColumnIndex:0];
        NSString *name = [rs stringForColumnIndex:1];
        int age = [rs intForColumnIndex:2];
        NSString *score = [rs stringForColumnIndex:3];
        Student *student = [[Student alloc] init];
        
        student.studentID = studentID;
        student.name = name;
        student.age = age;
        student.score = score;
        [_arrDataSource addObject:student];
    }
    
    [self.listTableView reloadData];
}

#pragma mark - DataBase
- (void)createDataBase {
    // 获取数据库文件的路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"student.sqlite"];
    NSLog(@"path = %@",path);
    // 1..创建数据库对象
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    _db = db;
    // 2.打开数据库
    if ([db open]) {
        // do something
        NSLog(@"Open database Success");
    } else {
        NSLog(@"fail to open database");
    }
}

- (void)createTable {
    if ([_db tableExists:@"t_student"]) {
        NSLog(@"t_student Table is exist");
        
        if (![_db columnExists:@"score" inTableWithName:@"t_student"]) {
            NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER", @"t_student", @"score"];
            BOOL worked = [_db executeUpdate:alertStr];
            if(worked){
                NSLog(@"Table t_student 插入score字段成功");
            }else{
                NSLog(@"Table t_student 插入score字段失败");
            }
        }
        
        return;
    }
    NSString *createTableSqlString = @"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL)";
    [_db executeUpdate:createTableSqlString];
}

@end
