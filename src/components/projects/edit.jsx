// OGPToolbox-Editor -- Web editor for OGP toolbox
// By: Emmanuel Raviart <emmanuel.raviart@data.gouv.fr>
//
// Copyright (C) 2016 Etalab
// https://git.framasoft.org/etalab/ogptoolbox-editor
//
// OGPToolbox-Editor is free software you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// OGPToolbox-Editor is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


import {Component, PropTypes} from "react"
import Form from "react-jsonschema-form"
import {connect} from "react-redux"

import {loadProject, updateProject} from "../../actions"
import {schema, uiSchema} from "../../schemas/project"


class ProjectEdit extends Component {
  static breadcrumbName = "Edit Project"
  static propTypes = {
    authentication: PropTypes.object.isRequired,
    loadProject: PropTypes.func.isRequired,
    projectById: PropTypes.object.isRequired,
    updateProject: PropTypes.func.isRequired,
  }
  componentWillMount() {
    this.props.loadProject(this.props.authentication, this.props.params.id)
  }
  onSubmit(form) {
    const {authentication, params, updateProject} = this.props
    updateProject(authentication, params.id, form.formData)
  }
  render() {
    const {authentication, loadProject, params, projectById} = this.props
    const project = projectById[params.id]
    if (!project) return (
      <p>Loading {params.id}...</p>
    )
    return (
      <Form
        formData={project}
        onSubmit={this.onSubmit.bind(this)}
        schema={schema}
        uiSchema={uiSchema}
      />
    )
  }
}

export default connect(
  state => ({
    authentication: state.authentication,
    projectById: state.projectById,
  }),
  {
    loadProject,
    updateProject,
  },
)(ProjectEdit)
