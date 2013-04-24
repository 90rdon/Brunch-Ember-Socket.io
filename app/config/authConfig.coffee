Auth.Config.reopen
  tokenCreateUrl:                   '/users/sign_in'
  tokenDestroyUrl:                  '/users/sign_out'
  tokenKey:                         'auth_token'

  idKey:                            'user_id'
  rememberMe:                       true
  rememberTokenKey:                 'remember_token'
  rememberPeriod:                   7
  
  authRedirect:                     true
  smartSignInRedirect:              true
  smartSignOutRedirect:             true
  signInRoute:                      'signIn'
  signOutRoute:                     'signOut'
  signInRedirectFallbackRoute:      'home'
  signOutRedirectFallbackRoute:     'home'