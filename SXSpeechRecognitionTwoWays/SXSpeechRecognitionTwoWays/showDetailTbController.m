//
//  showDetailTbController.m
//  SpeechRecognition
//
//  Created by 孙道伟 on 17/4/19.
//  Copyright © 2017年 Sankuai. All rights reserved.
//

#import "showDetailTbController.h"
#import "ViewController.h"
#import "messageDeatilVController.h"
@interface showDetailTbController ()
/** 记录的数组 */
@property (nonatomic,strong) NSMutableArray * muArray ;


@end

@implementation showDetailTbController



-(NSMutableArray *)muArray{
    if (_muArray==nil) {
        _muArray = [NSMutableArray array];
    }
    return _muArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    // 文件管理
    NSFileManager *manger = [NSFileManager defaultManager];

   // 获取主沙盒下的Documents
    NSString *DocumentPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];

    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:DocumentPath];


    NSMutableArray *tempArr = [NSMutableArray array];
    // 遍历沙盒下的目录文件
    for (NSString *fileName in enumerator) {

       // NSLog(@"每一项的内容----%@", fileName);


        NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);//设置文件路径
        NSString *homePath = [paths objectAtIndex:0];//获取当前路径
         NSString *filePath= [homePath stringByAppendingPathComponent:fileName];//获取文件路径
       // 从一个文件中读取数据，返回一个NSData类型
       NSData *data =  [manger  contentsAtPath:filePath];
       // NSData->NSString
      NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

    //暂存在临时数组中
     [tempArr addObject:result];


    }
    self.muArray = tempArr;

    //NSLog(@"所有的数组内容----%@",self.muArray);

    [self.tableView reloadData];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.muArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * ID = @"cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];

    if (cell ==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];

    }
    // Configure the cell...
    NSString * text = self.muArray[indexPath.row];
    // 截取字符串，用来显示在tableView上作为一个简介；
    NSString * head = [text substringToIndex:4];

    cell.textLabel.text = head;
    
    return cell;
}


#pragma mark- talbleViewDelegate

//选中某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    messageDeatilVController *ms = [[messageDeatilVController alloc]init];
    ms.view.backgroundColor = [UIColor grayColor];
    NSString *strmessage = self.muArray[indexPath.row];
    UILabel *lable = [[UILabel alloc]init];

    lable.frame = CGRectMake(0, 0, 400, 250);
    lable.text = strmessage;
    lable.numberOfLines = 0; 
    [ms.view addSubview: lable];

    //跳转
    [self.navigationController pushViewController:ms animated:YES];
    NSLog(@"%@",strmessage);
    

    
}
/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
