Auth.Config.reopen
  tokenCreateUrl:                   '/api/token'
  tokenDestroyUrl:                  '/api/logout'
  tokenKey:                         'auth_token'
  # baseUrl:                          '/api'

  idKey:                            'user_id'
  rememberMe:                       true
  rememberTokenKey:                 'remember_token'
  rememberPeriod:                   7
  
  authRedirect:                     true
  smartSignInRedirect:              true
  smartSignOutRedirect:             true
  signInRoute:                      'signIn'
  signOutRoute:                     'signOut'
  signInRedirectFallbackRoute:      'member'
  signOutRedirectFallbackRoute:     'home'