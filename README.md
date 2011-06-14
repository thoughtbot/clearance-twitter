DEPRECATED
==========

This project is deprecated and no longer maintained. We recommend that you use [Omniauth](https://github.com/intridea/omniauth) instead.

Twitter Clearance
-----------------

Use Twitter OAuth authentication on top of Clearance.

1. Install:

    script/plugin install git@github.com:thoughtbot/clearance-twitter.git

2. Get to red by generating the features:

    script/generate clearance_twitter_features

3. Get to green by generating the code:

    script/generate clearance_twitter


The cucumber features use WebMock to fake twitter.com OAuth responses.
If you'd like to use another tool for this, see the generated file:

    features/support/clearance_twitter_support.rb
