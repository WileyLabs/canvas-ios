//
// Copyright (C) 2016-present Instructure, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 3 of the License.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

/**
 * @flow
 */

import Actions from '../actions'
import { filesData, foldersData } from '../reducer'

const template = {
  ...require('../../../__templates__/file'),
  ...require('../../../__templates__/folder'),
  ...require('../../../redux/__templates__/app-state'),
}

describe('CourseFileList', () => {
  it('files updated', () => {
    const file = template.file()
    const path = 'path'
    const id = '123'
    const type = 'Course'
    const action = Actions.filesUpdated([file], path, id, type)
    const result = filesData(template.appState(), action)
    expect(result).toMatchObject({
      [`${type}-${id}`]: {
        [path]: [file],
      },
    })
  })

  it('folders updated', () => {
    const folder = template.folder()
    const path = 'path'
    const id = '123'
    const type = 'Course'
    const action = Actions.foldersUpdated([folder], path, id, type)
    const result = foldersData(template.appState(), action)
    expect(result).toMatchObject({
      [`${type}-${id}`]: {
        [path]: [folder],
      },
    })
  })
})