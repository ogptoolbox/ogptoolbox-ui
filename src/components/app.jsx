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
import {MenuItem, Nav, Navbar, NavDropdown, NavItem} from "react-bootstrap"
import {connect} from "react-redux"
import {Link} from "react-router"
import {LinkContainer} from "react-router-bootstrap"

import {loadAuthenticationCookie} from "../actions"
import config from "../config"
import Breadcrumbs from "./breadcrumbs"


class App extends Component {
  static breadcrumbName = "Home"
  static propTypes = {
    authentication: PropTypes.object,
    children: PropTypes.node,
    language: PropTypes.string.isRequired,
    loadAuthenticationCookie: PropTypes.func.isRequired,
  }
  componentWillMount() {
    this.props.loadAuthenticationCookie()
  }
  render() {
    const {authentication, children, language, location, params, routes} = this.props
    const profileLink = authentication && Object.keys(authentication).length > 0 ? (
      <LinkContainer to={`/${language}/profile`}><NavItem>{authentication.name}</NavItem></LinkContainer>
    ) : null
    const signInOrOutLink = authentication && Object.keys(authentication).length > 0 ? (
      <LinkContainer to={`/${language}/sign_out`}><NavItem>Sign Out</NavItem></LinkContainer>
    ) : (
      <LinkContainer to={`/${language}/sign_in`}><NavItem>Sign In</NavItem></LinkContainer>
    )
    const signUpLink = authentication && Object.keys(authentication).length > 0 ? null : (
      <LinkContainer to={`/${language}/sign_up`}><NavItem>Sign up</NavItem></LinkContainer>
    )
              // <LinkContainer to={`/${language}/about`}><NavItem eventKey={1}>About</NavItem></LinkContainer>
        // <Breadcrumbs
        //   itemClassName={"btn button-narrow"}
        //   linkClassName={"btn button-narrow"}
        //   params={params}
        //   routes={routes}
        //   wrapperClassName={"mxn1"}
        // />
    return (
      <div className="container-fluid">
        <Navbar fixedTop fluid inverse>
          <Navbar.Header>
            <Navbar.Brand>
              <Link to={`/${language}/`}>{config.title}</Link>
            </Navbar.Brand>
            <Navbar.Toggle />
          </Navbar.Header>
          <Navbar.Collapse>
            <Nav>
              <LinkContainer to={`/${language}/tools`}><NavItem>Tools</NavItem></LinkContainer>
              <LinkContainer to={`/${language}/projects`}><NavItem>Projects</NavItem></LinkContainer>
              <LinkContainer to={`/${language}/methods`}><NavItem>Methods</NavItem></LinkContainer>
            </Nav>
            <Nav pullRight>
              <NavDropdown title={(<span className="lang-sm lang-lbl" lang={language}></span>)} id="basic-nav-dropdown">
                <LinkContainer to={{
                  ...location,
                  pathname: `/en${location.pathname.substr(1 + language.length)}`,
                }}>
                  <MenuItem><span className="lang-sm lang-lbl" lang="en"></span></MenuItem>
                </LinkContainer>
                <LinkContainer to={{
                  ...location,
                  pathname: `/fr${location.pathname.substr(1 + language.length)}`,
                }}>
                  <MenuItem><span className="lang-sm lang-lbl" lang="fr"></span></MenuItem>
                </LinkContainer>
              </NavDropdown>
              {profileLink}
              {signInOrOutLink}
              {signUpLink}
            </Nav>
          </Navbar.Collapse>
        </Navbar>
        {children}
      </div>
    )
  }
}

export default connect(
  state => ({
    authentication: state.authentication,
    language: state.language,
  }),
  {
    loadAuthenticationCookie,
  },
)(App)