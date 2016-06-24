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

import {deleteTool, loadTool} from "../actions"
import {schema, uiSchema as originalUiSchema} from "../schemas/tool"


const uiSchema = {...originalUiSchema}
for (let [propertyId, property] of Object.entries(schema.properties)) {
  if (uiSchema[propertyId] == undefined) uiSchema[propertyId] = {}
  uiSchema[propertyId]["ui:disabled"] = true
}


class ToolDelete extends Component {
  static breadcrumbName = "Delete Tool"
  static propTypes = {
    authentication: PropTypes.object,
    deleteTool: PropTypes.func.isRequired,
    loadTool: PropTypes.func.isRequired,
    toolById: PropTypes.object.isRequired,
  }
  componentWillMount() {
    this.props.loadTool(this.props.authentication, this.props.params.id)
  }
  onSubmit(form) {
    const {authentication, deleteTool, params} = this.props
    deleteTool(authentication, params.id)
  }
  render() {
    const {authentication, loadTool, params, toolById} = this.props
    const tool = toolById[params.id]
    if (!tool) return (
      <p>Loading {params.id}...</p>
    )
    return (
      <Form
        formData={tool}
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
    toolById: state.toolById,
  }),
  {
    deleteTool,
    loadTool,
  },
)(ToolDelete)
