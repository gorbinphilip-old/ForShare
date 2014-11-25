ForShare
========

A simple web app built on rails to host files and share with OAuth.

Checkout deployment at [ForShare](https://forshare.herokuapp.com/)

Working:
---------
The app provides a file hosting service and sharing of such files to
sites with OAuth secured authorisation.  The application can handle
multiple OAuth providers.  The admin user can create Oauthclients
corresponding to a provider. The normal user can then authorize the
Oauthclient.  Once authorized the Oauthclient obtains token directly
from provider. Now the user can share the uploaded files to specified
post_url in the Oauthclient with additional params if necessary.

Workflow:
--------
1. Admin creates Oauthclient.
2. User authorizes Oauthclient.
3. User uploads files.
4. User shares uploaded files.