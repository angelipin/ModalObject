ModalObject
===========

Tutorial:
Declear a Modal object:
# header file
@interface Book : Modal  
Property_Declear(NSString *, author, queryAuthor, nonatomic, retain);
Property_Declear(NSString *, title, queryTitle, nonatomic, retain);
Property_Declear(NSDate *, publicDate, queryPublicDate, nonatomic, retain);
Property_Declear(NSString *, isbn, queryIsbn, nonatomic, retain);
@end
# source file
@implementation huangli  
Property_Implement(author, queryAuthor);  
Property_Implement(title, queryTitle);  
Property_Implement(publicDate, queryPublicDate);  
Property_Implement(isbn, queryIsbn);

- (void)dealloc {  
    [_author release];  
    [_title release];  
    [_publicDate release];  
    [_isbn release];   
      
    [super dealloc];  
}  
@end

How to use:

# first of all: 
[Modal initEnvironment];
// first copy db file to a writable directory
[Book registeDatabase:@"Your database file path"];

# Then We can use it like follow:
Book *book = [[Book alloc] init];
book.author = @"angleipin";
book.publicDate = [NSDate date];
book.title = @"Modal Object";
book.isbn = @"ISBN:0000-0000-0";
[book insert];

# And also:
Book *book = [Book queryAuthor:@"angelipin"];
if (book) {
    [book setPublicDate:[NSDate date]];
    [book modify];
}


