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

import {loadAuthenticationCookie} from "../actions"
import config from "../config"
import Breadcrumbs from "./breadcrumbs"


export default class App extends Component {
  static breadcrumbName = "Home"
  static propTypes = {
    authentication: PropTypes.object,
    loadAuthenticationCookie: PropTypes.func.isRequired,
    children: PropTypes.node,
  }
  componentWillMount() {
    this.props.loadAuthenticationCookie()
  }
  render() {
    const {authentication, children, loadAuthenticationCookie, params, routes} = this.props
    const profileLink = authentication && Object.keys(authentication).length > 0 ? (
      <li><Link to="/profile">{authentication.name}</Link></li>
    ) : null
    const signInOrOutLink = authentication && Object.keys(authentication).length > 0 ? (
      <li><Link to="/sign_out">Sign Out</Link></li>
    ) : (
      <li><Link to="/sign_in">Sign In</Link></li>
    )
    const signUpLink = authentication && Object.keys(authentication).length > 0 ? null : (
      <li><Link to="/sign_up">Sign Up</Link></li>
    )
    return (
      <div className="container-fluid">
        <nav className="navbar navbar-default navbar-fixed-top">
          <div className="container-fluid">
            <div className="navbar-header">
              <button type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target="#top-navbar-collapse" aria-expanded="false">
                <span className="sr-only">Toggle navigation</span>
                <span className="icon-bar"></span>
                <span className="icon-bar"></span>
                <span className="icon-bar"></span>
              </button>
              <Link className="navbar-brand" to="/">
                {config.title}
              </Link>
            </div>

            <div className="collapse navbar-collapse" id="top-navbar-collapse">
              <ul className="nav navbar-nav">
                <li><Link to="/about">About</Link></li>
                <li><Link to="/methods">Methods</Link></li>
                <li><Link to="/projects">Projects</Link></li>
                <li><Link to="/tools">Tools</Link></li>
              </ul>
              <ul className="nav navbar-nav navbar-right">
                {profileLink}
                {signInOrOutLink}
                {signUpLink}
              </ul>
            </div>
          </div>
        </nav>
        <Breadcrumbs
          itemClassName={"btn button-narrow"}
          linkClassName={"btn button-narrow"}
          params={params}
          routes={routes}
          wrapperClassName={"mxn1"}
        />
        {children}
      </div>
    )
  }
}

export default connect(
  state => ({authentication: state.authentication}),
  {
    loadAuthenticationCookie,
  },
)(App)