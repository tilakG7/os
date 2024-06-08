#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <iostream>

using namespace std;

int main() {
    cout << "Hello from Process PID = " << getpid() << endl;
    int rc = fork(); // fork parent process
    if(rc < 0) {
        // fork failed
        cerr << "Error forking process" << endl;
    } else if(rc == 0) {
        // child process
        cout << "This is the child process. PID: " << static_cast<int>(getpid()) << endl;
        char *myargs[3];
        myargs[0] = "wc";
        myargs[1] = "exec.cpp";
        myargs[2] = NULL;
        execvp(myargs[0], myargs);
        cout << "This shouldn't print" << endl;
    } else {
        int rc_wait = wait(nullptr);
        // parent goes down this path
        cout << "PID: " << getpid() << ", parent of child process: " << rc << endl;
        cout << "Wait value: " << rc_wait << endl;
    }
    return 0;
}