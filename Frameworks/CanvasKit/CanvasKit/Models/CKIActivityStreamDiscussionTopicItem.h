//
// This file is part of Canvas.
// Copyright (C) 2017-present  Instructure, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

#import "CKIActivityStreamItem.h"

/**
 Activity stream item for both discussions and annoucements.
 */

@interface CKIActivityStreamDiscussionTopicItem : CKIActivityStreamItem

/**
 The number of root discussion entries.
 */
@property (nonatomic) NSInteger totalRootDiscussionEntries;

/**
 An initial post is required.
 */
@property (nonatomic) BOOL requireInitialPost;

/**
 The current user has posted to the discussion.
 */
@property (nonatomic) BOOL userHasPosted;

/**
 The ID of the discussion topic.
 */
@property (nonatomic, copy) NSString * discussionTopicID;

@end
