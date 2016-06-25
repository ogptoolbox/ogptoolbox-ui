// OGPToolbox-Editor -- Web editor for OGP toolbox
// By: Emmanuel Raviart <emmanuel.raviart@data.gouv.fr>
//
// Copyright (C) 2016 Etalab
// https://git.framasoft.org/etalab/ogptoolbox-editor
//
// OGPToolbox-Editor is free software; you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// OGPToolbox-Editor is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


import {Component, PropTypes} from "react"
import {Link} from "react-router"


export default class ProjectLine extends Component {
  static propTypes = {
    project: PropTypes.object.isRequired,
  }
  render() {
    const {project} = this.props
    return (
      <div class="list-group">
        <a href={`/projects/${project.id}`} class="list-group-item active">
          <h4 class="list-group-item-heading">{project.name}</h4>
          <p class="list-group-item-text">{project.description}</p>
        </a>
      </div>
    )
  }
}
