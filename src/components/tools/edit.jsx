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

import {loadTool, updateTool} from "../../actions"


class ToolEdit extends Component {
  static breadcrumbName = "Edit Tool"
  static propTypes = {
    authentication: PropTypes.object.isRequired,
    language: PropTypes.string.isRequired,
    loadTool: PropTypes.func.isRequired,
    toolById: PropTypes.object.isRequired,
    updateTool: PropTypes.func.isRequired,
  }
  componentWillMount() {
    this.props.loadTool(this.props.authentication, this.props.params.id)
  }
  onSubmit(form) {
    const {authentication, params, updateTool} = this.props
    updateTool(authentication, params.id, form.formData)
  }
  render() {
    const {authentication, language, loadTool, params, toolById} = this.props
    const schemaModule = require(`../../schemas/${language}/tool`)
    const schema = schemaModule.schema
    const uiSchema = schemaModule.uiSchema
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
      />
    )
  }
}

export default connect(
  state => ({
    authentication: state.authentication,
    language: state.language,
    toolById: state.toolById,
  }),
  {
    loadTool,
    updateTool,
  },
)(ToolEdit)
