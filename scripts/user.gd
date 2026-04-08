class_name User
extends Resource
## A data file containing all persistent information about a user.
##
## The User resource contains all information about a DoorOS user that 
## persists between loads. 

## The unique username for the user. Used to identify the user.
var username: String
## The display name of the user shown on the log-in screen, among other places.
var display_name: String
## Determines if the user has admin privileges, which gives the user access
## to everything on the system, including system files
var admin: bool

## The SHA256 hash of the user's password.
var password: String
