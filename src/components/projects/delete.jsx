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

import {deleteProject, loadProject} from "../../actions"


class ProjectDelete extends Component {
  static breadcrumbName = "Delete Project"
  static propTypes = {
    authentication: PropTypes.object,
    deleteProject: PropTypes.func.isRequired,
    language: PropTypes.string.isRequired,
    loadProject: PropTypes.func.isRequired,
    projectById: PropTypes.object.isRequired,
  }
  componentWillMount() {
    this.props.loadProject(this.props.authentication, this.props.params.id)
  }
  onSubmit(form) {
    const {authentication, deleteProject, params} = this.props
    deleteProject(authentication, params.id)
  }
  render() {
    const {authentication, language, loadProject, params, projectById} = this.props
    const schemaModule = require(`../../schemas/${language}/project`)
    const schema = schemaModule.schema
    const uiSchema = {...schemaModule.uiSchema}
    for (let [propertyId, property] of Object.entries(schema.properties)) {
      if (uiSchema[propertyId] == undefined) uiSchema[propertyId] = {}
      else uiSchema[propertyId] = {...uiSchema[propertyId]}
      uiSchema[propertyId]["ui:disabled"] = true
    }
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
      >
        <div>
          <button className="btn btn-danger" type="submit">Delete</button>
        </div>
      </Form>
    )
  }
}

export default connect(
  state => ({
    authentication: state.authentication,
    language: state.language,
    projectById: state.projectById,
  }),
  {
    deleteProject,
    loadProject,
  },
)(ProjectDelete)
