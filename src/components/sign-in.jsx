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
import {reduxForm} from "redux-form"

import {signIn} from "../actions"


const submit = (values, dispatch) => new Promise((resolve, reject) => dispatch(signIn(values, resolve, reject)))


class SignIn extends Component {
  static propTypes = {
    fields: PropTypes.object.isRequired,
    handleSubmit: PropTypes.func.isRequired,
    submitting: PropTypes.bool.isRequired
  }
  render() {
    const {fields: {username, password}, handleSubmit, submitting} = this.props
    return (
      <form onSubmit={handleSubmit(submit)}>
        <div className="form-group">
          <label htmlFor="username">Username</label>
          <input className="form-control" id="username" placeholder="John Doe" type="text" {...username} />
        </div>
        <div className="form-group">
          <label htmlFor="password">Password</label>
          <input className="form-control" id="password" type="password" {...password} />
        </div>
        <button className="btn btn-default" disabled={submitting} type="submit">Sign In</button>
      </form>
    )
  }
}

export default reduxForm({
  fields: ["username", "password"],
  form: "sign-in",
})(SignIn)