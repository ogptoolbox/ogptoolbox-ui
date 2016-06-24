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

import {signOut} from "../actions"


const submit = (values, dispatch) => new Promise((resolve, reject) => dispatch(signOut(resolve, reject)))


class SignOut extends Component {
  static propTypes = {
    handleSubmit: PropTypes.func.isRequired,
    submitting: PropTypes.bool.isRequired
  }
  render() {
    const {handleSubmit, submitting} = this.props
    return (
      <form onSubmit={handleSubmit(submit)}>
        <button className="btn btn-default" disabled={submitting} type="submit">Sign Out</button>
      </form>
    )
  }
}

export default reduxForm({
  fields: [],
  form: "sign-out",
})(SignOut)