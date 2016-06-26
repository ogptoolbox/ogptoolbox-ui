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

import {loadMethod, updateMethod} from "../../actions"
import {schema, uiSchema} from "../../schemas/method"


class MethodEdit extends Component {
  static breadcrumbName = "Edit Method"
  static propTypes = {
    authentication: PropTypes.object.isRequired,
    loadMethod: PropTypes.func.isRequired,
    methodById: PropTypes.object.isRequired,
    updateMethod: PropTypes.func.isRequired,
  }
  componentWillMount() {
    this.props.loadMethod(this.props.authentication, this.props.params.id)
  }
  onSubmit(form) {
    const {authentication, params, updateMethod} = this.props
    updateMethod(authentication, params.id, form.formData)
  }
  render() {
    const {authentication, loadMethod, params, methodById} = this.props
    const method = methodById[params.id]
    if (!method) return (
      <p>Loading {params.id}...</p>
    )
    return (
      <Form
        formData={method}
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
    methodById: state.methodById,
  }),
  {
    loadMethod,
    updateMethod,
  },
)(MethodEdit)
