// CA3.cpp : Defines the entry point for the console application.
//

#include "FBL.h"
#include <iostream>
#include <string>
using namespace std;

#define ParaSize	5

int menuLevel = 0;
string loginUserID = "";

void FBLUserLL::displayall() {
	FBLUser *p;
	p = head;

	while (p != NULL ) {
		//Display all user list;
		printf("%s\t %s\t %s\t %s\n", p->mUserid.c_str(), p->mPasswd.c_str(), p->mLastname.c_str(), p->mFirstname.c_str());
		p = p->next;
	}
}


//Create new user and add to list
void FBLUserLL::insertnode(string userid, string passwd, string firstname, string lastname) {
	FBLUser* newnode;

	//new user node and add to linked list
	newnode = new FBLUser;
	newnode->mUserid = userid;
	newnode->mPasswd = passwd;
	newnode->mFirstname = firstname;
	newnode->mLastname = lastname;
	newnode->postlist = new FBLPostLL;
	newnode->next = head;

	//Move head pointer
	head = newnode;
}

//Check duplicate userid by traversing list
bool FBLUserLL::isUseridExist(string userid) {
	FBLUser *p;
	p = head;
	while (p != NULL) {
		//If user found, return ture
		if (p->mUserid.c_str() == userid) {
			//printf("Duplicate user id:%s == %s\n", p->mUserid.c_str(), userid.c_str());
			return true;
		}			
		p = p->next;
	}
	return false;
}

//get user data by id
FBLUser FBLUserLL::getUser(string userid) {
	FBLUser *p, userdata;
	p = head;
	while (p != NULL) {
		//if user found, return user node
		if (p->mUserid.c_str() == userid) {
			//get user data by id;
			userdata = *p;
		}
		p = p->next;
	}
	return userdata;
}

//Check duplicate userid by traversing list
void FBLUserLL::deletenode(string userid) {
	FBLUser *p, *prev;
	p = head;
	prev = NULL;
	while (p != NULL) {
		//go through list
		if (p->mUserid.c_str() == userid) {			
			//delete node at head
			if (prev == NULL) {
				//move head
				head = p->next;
				prev = p;
			}
			//link next node to previous node
			prev->next = p->next;
			delete p;
			break;
		}
		prev = p;
		p = p->next;
	}
}

string FBLPostLL::getPosttext(string cmdline) {
	short counter = 0;
	string strText;
	for (short i = 0; i < cmdline.length(); i++) {
		if (cmdline[i] == ' ' &&  counter==0) {
			//printf("%s\n", strPara[counter].c_str());
			counter++;
			i++;
		}
		if(counter == 1) {
			strText += cmdline[i];
		}
	}
	return strText;
}

void FBLPostLL::displayall() {
	FBLPost *p;
	p = head;

	while (p != NULL) {
		//Display all user list;
		printf("%s\t %d\n", p->mText.c_str(),p->likeCounter);
		p = p->next;
	}
}

//add postcommend node to back
void FBLPostLL::insertnode(string text) {
	FBLPost* newnode;

	//new user node and add to linked list
	newnode = new FBLPost;
	newnode->likeCounter = 0;
	newnode->mText = text;
	newnode->next = NULL;

	//Move head pointer
	if (tail == NULL) 
	{
		head = newnode;
		tail = newnode;
	}
	else
	{
		tail->next = newnode;
		tail = newnode;
	}
}

//add postcommend node to back
void FBLPostLL::deletenode() {
	FBLPost *tmp;
	if (head == NULL) {
		cout << "Nothing to read.\n";
	}
	else {
		tmp = head;
		if (head == tail) {
			head = NULL;
			tail = NULL;
		}
		else {
			head = head->next;
		}		
		delete tmp;
	}
}

int main(int argc, char *argv[])
{
	FBLUserLL Userlist;
	string cmdline;
	string strPara[ParaSize];
	short counter = 0;
	while (getline(cin, cmdline)) {
		/*=============== paser input command line ============*/
		counter = 0;
		//Clear strPara string array
		for (short i = 0; i < ParaSize; i++) {
			strPara[i].clear();
		}			

		for (short i = 0; i < cmdline.length(); i++) {			
			if (cmdline[i] == ' ') {				
				//printf("%s\n", strPara[counter].c_str());
				counter++;
			}
			else {
				strPara[counter] += cmdline[i];
			}
			if (counter == ParaSize)
				break;
		}

		/*=============== paser parameters ============*/
		if (strPara[0] == "QUIT")
			return 0;
		
		// menu level-1
		if (menuLevel == 0) {
			if (strPara[0]=="CREATE") {
				if (!Userlist.isUseridExist(strPara[1])) {
					Userlist.insertnode(strPara[1], strPara[2], strPara[3], strPara[4]);
					Userlist.displayall();
				}
			}
			else if (strPara[0] == "DELETE") {				
					Userlist.deletenode(strPara[1]);
					Userlist.displayall();
			}
			else if (strPara[0] == "LISTUSER") {
				Userlist.displayall();
			}
			else if (strPara[0] == "LOGIN") {
				if (Userlist.isUseridExist(strPara[1])) {
					FBLUser userdata= Userlist.getUser(strPara[1]);
					if (userdata.mPasswd == strPara[2]) {
						menuLevel = 1;
						loginUserID = strPara[1];
						cout << "Welcome," << userdata.mFirstname << " " << userdata.mLastname << "\n";
					}
					else {
						cout << "Password is not correct!\n";
					}
				}
				else {
					cout << "User" << strPara[1] << " is not exist!\n";
				}
			}
			else {
				cout << "Top Level.\n Usage:\n \t1) CREATE <Userid> <Password> <First> <Last> \n\t2) LOGIN <Userid> \n\t3) QUIT\n";
			}
		}
		// menu level-2
		else {
			FBLUser userdata = Userlist.getUser(loginUserID);
			if (strPara[0] == "LOGOUT") {
				FBLUser userdata = Userlist.getUser(loginUserID);
				cout << "Good bye," << userdata.mFirstname << " " << userdata.mLastname << "\n";
				menuLevel = 0;
				loginUserID = "";
			}
			else if (strPara[0] == "POST") {
				//add psot text to user's post list.
				userdata.postlist->insertnode(FBLPostLL::getPosttext(cmdline));
				userdata.postlist->displayall();
			}
			else if (strPara[0] == "LISTPOST") {
				//Display all post of user;
				userdata.postlist->displayall();
			}
			else if (strPara[0] == "READ") {
				//remove first node at head;
				userdata.postlist->deletenode();
				userdata.postlist->displayall();
			}
			else {
				cout << "Welcome," << userdata.mFirstname << " " << userdata.mLastname << "\n";
				cout << "2nd Level.\n Usage:\n \t1) LOGOUT \n\t2) POST <text>\n\t3) READ\n";
			}			
		}
	}

    return 0;
}

