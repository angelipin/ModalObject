ModalObject
===========

# Tutorial:
Declear a Modal object:
# header file   
@interface Book : Modal   <br/>
Property_Declear(NSString *, author, queryAuthor, nonatomic, retain);<br/>
Property_Declear(NSString *, title, queryTitle, nonatomic, retain);<br/>
Property_Declear(NSDate *, publicDate, queryPublicDate, nonatomic, retain);<br/>
Property_Declear(NSString *, isbn, queryIsbn, nonatomic, retain);<br/>
@end<br/>
# source file
@implementation huangli  <br/>
Property_Implement(author, queryAuthor);  <br/>
Property_Implement(title, queryTitle);  <br/>
Property_Implement(publicDate, queryPublicDate);  <br/>
Property_Implement(isbn, queryIsbn);<br/>

- (void)dealloc {  <br/>
    [_author release]; <br/> 
    [_title release];  <br/>
    [_publicDate release];  <br/>
    [_isbn release];   <br/>
    [super dealloc];  <br/>
}  <br/>
@end<br/>

How to use:

# first of all: 
[Modal initEnvironment];<br/>
// first copy db file to a writable directory
[Book registeDatabase:@"Your database file path"];<br/>

# Then We can use it like follow:
Book *book = [[Book alloc] init];<br/>
book.author = @"angleipin";<br/>
book.publicDate = [NSDate date];<br/>
book.title = @"Modal Object";<br/>
book.isbn = @"ISBN:0000-0000-0";<br/>
[book insert];<br/>

# And also:
Book *book = [Book queryAuthor:@"angelipin"];<br/>
if (book) {<br/>
    [book setPublicDate:[NSDate date]];<br/>
    [book modify];<br/>
}<br/>


