This is am improvement based on the already advertized Steam Windows Log Rotator for Arelith. See existing offer:

https://wiki.nwnarelith.com/Logs/Script#:~:text=TODAY%25%2D%25NOW%25.txt-,Using%20Steam%20install%20running%20through%20steam,-Advantage%20of%20using



This version works in 99% of cases, however in the case where your PC crashes, the terminal is closed before the game or any other potential error that would prevent the logs from being preserved, they would simply be overridden.


This modification catches those two edge cases, checking *before* the game launches if the logfile exists. If so, do the exact same process, just before.
