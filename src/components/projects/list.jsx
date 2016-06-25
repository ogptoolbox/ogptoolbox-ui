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
import {connect} from "react-redux"
import {Link} from "react-router"

import {loadProjects} from "../../actions"
import ProjectLine from "./line"


class ProjectsList extends Component {
  static propTypes = {
    authentication: PropTypes.object,
    loadProjects: PropTypes.func.isRequired,
    projects: PropTypes.arrayOf(PropTypes.object),
  }
  componentWillMount() {
    this.props.loadProjects(this.props.authentication)
  }
  render() {
    const {authentication, loadProjects, projects} = this.props
    return (
      <section>
        <h1>Projects</h1>
        {projects.map(project => <ProjectLine key={project.id} project={project} />)}
        {authentication && Object.keys(authentication).length > 0 ? (
          <Link className="btn btn-default" role="button" to="/projects/new">New Project</Link>
        ) : null}
      </section>
    )
  }
}

export default connect(
  state => ({
    authentication: state.authentication,
    projects: state.projectIds ? state.projectIds.map(projectId => state.projectById[projectId]) : [],
  }),
  {
    loadProjects,
  },
)(ProjectsList)