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
import {Link} from "react-router"

import {loadTool} from "../../actions"
import {schema, uiSchema as originalUiSchema} from "../../schemas/tool"


const uiSchema = {...originalUiSchema}
for (let [propertyId, property] of Object.entries(schema.properties)) {
  if (uiSchema[propertyId] == undefined) uiSchema[propertyId] = {}
  uiSchema[propertyId]["ui:disabled"] = true
}


class ToolView extends Component {
  static propTypes = {
    authentication: PropTypes.object,
    loadTool: PropTypes.func.isRequired,
    toolById: PropTypes.object.isRequired,
  }
  componentWillMount() {
    this.props.loadTool(this.props.authentication, this.props.params.id)
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
        schema={schema}
        uiSchema={uiSchema}
      >
        <div>
          {authentication && Object.keys(authentication).length > 0 ? (
            <Link className="btn btn-default" role="button" to={`/tools/${tool.id}/edit`}>Edit</Link>
          ) : null}
          {authentication && Object.keys(authentication).length > 0 ? (
            <Link className="btn btn-danger" role="button" to={`/tools/${tool.id}/delete`}>Delete</Link>
          ) : null}
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
    loadTool,
  },
)(ToolView)
