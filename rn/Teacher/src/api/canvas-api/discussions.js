/* @flow */

import httpClient from './httpClient'
import { paginate, exhaust } from '../utils/pagination'

type GetDiscussionsParameters = {
  only_announcents?: boolean,
}

export function getDiscussions (courseID: string, parameters: GetDiscussionsParameters = {}): Promise<ApiResponse<Discussion[]>> {
  const url = `courses/${courseID}/discussion_topics`
  const options = {
    params: {
      per_page: 99,
      ...parameters,
    },
  }
  let discussions = paginate(url, options)
  return exhaust(discussions)
}

export function getAllDiscussionEntries (courseID: string, discussionID: string): Promise<ApiResponse<DiscussionView>> {
  const url = `courses/${courseID}/discussion_topics/${discussionID}/view`
  return httpClient().get(url)
}
