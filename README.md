
# Project Name: *Swift-Assignment-3:Twitter*

Time spent: **18** hours spent in total

## User Stories

The following **required** functionality is completed:

 - [x] User can sign in using OAuth login flow
 - [x] User can view last 20 tweets from their home timeline
 - [x] The current signed in user will be persisted across restarts
 - [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp. In other words, design the custom cell with the proper Auto Layout settings. You will also need to augment the model classes.
 - [x] User can pull to refresh
 - [x] User can compose a new tweet by tapping on a compose button.
 - [] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
 - [] User can retweet, favorite, and reply to the tweet directly from the timeline feed

The following **optional** features are implemented:

 - [x] When composing, you should have a countdown in the upper right for the tweet limit.
 - [] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
 - [] Retweeting and favoriting should increment the retweet and favorite count.
 - [] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
 - [] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
 - [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

## Video Walkthrough

Here's a walkthrough of implemented user stories:
https://github.com/dunghuynh1990/Swift-Assignment-3--Twitter/blob/master/Jul-24-2016%2023-57-10.gif

## Setup
Pods aren't checked in to source control, so please run `pod install` then open `Swift-Assignment-3.xcworkspace` and run in Xcode. Tested Xcode version: 7.3.1

## License

    Copyright [2016] [Huynh Tri Dung]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
