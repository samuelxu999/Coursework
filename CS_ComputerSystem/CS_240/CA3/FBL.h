#include <iostream>
using namespace std;

class FBLPost {
	public:
		string mText;				//post text
		int likeCounter;			//count the number if likes
		FBLPost *next;				//Node pointers to next and previous
};

class FBLPostLL {
private:
	FBLPost *head, *tail;				//Node pointers to head and tail
	public:
		FBLPostLL() {               //default constructor
			head = NULL;
			tail = NULL;
		}
		static string getPosttext(string cmdline);
		void insertnode(string text);
		void deletenode();
		void displayall();
	};

class FBLUser {
	public:
		string mUserid;			//unique userid
		string mPasswd;			//password
		string mFirstname;		//First name
		string mLastname;		//Last name
		FBLUser *next;			//Node pointers to next and previous
		FBLPostLL *postlist;		//post comment list
};

class FBLUserLL {
	private:
		FBLUser *head;				//Node pointers to head and tail
	public:
		FBLUserLL() {               //default constructor
			head = NULL;
		}
		void insertnode(string userid, string passwd, string firstname, string lastname);
		void deletenode(string userid);
		void displayall();
		bool isUseridExist(string userid);
		FBLUser getUser(string userid);
};



