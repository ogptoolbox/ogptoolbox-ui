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


import {IndexRoute, Route} from "react-router"

// import About from "./components/about"
import App from "./components/app"
import Home from "./components/home"
import NotFound from "./components/not-found"
import Profile from "./components/profile"
import MethodDelete from "./components/methods/delete"
import MethodEdit from "./components/methods/edit"
import Methods from "./components/methods/index"
import MethodsList from "./components/methods/list"
import MethodNew from "./components/methods/new"
import MethodView from "./components/methods/view"
import ProjectDelete from "./components/projects/delete"
import ProjectEdit from "./components/projects/edit"
import Projects from "./components/projects/index"
import ProjectsList from "./components/projects/list"
import ProjectNew from "./components/projects/new"
import ProjectView from "./components/projects/view"
import SignIn from "./components/sign-in"
import SignOut from "./components/sign-out"
import SignUp from "./components/sign-up"
import ToolDelete from "./components/tools/delete"
import ToolEdit from "./components/tools/edit"
import Tools from "./components/tools/index"
import ToolsList from "./components/tools/list"
import ToolNew from "./components/tools/new"
import ToolView from "./components/tools/view"


export default (
  <Route component={App} path="/">
    <IndexRoute component={Home} />
    <Route component={Methods} path="methods">
      <IndexRoute component={MethodsList} />
      <Route component={MethodNew} path="new" />
      <Route component={MethodView} path=":id" />
      <Route component={MethodDelete} path=":id/delete" />
      <Route component={MethodEdit} path=":id/edit" />
    </Route>
    <Route component={Projects} path="projects">
      <IndexRoute component={ProjectsList} />
      <Route component={ProjectNew} path="new" />
      <Route component={ProjectView} path=":id" />
      <Route component={ProjectDelete} path=":id/delete" />
      <Route component={ProjectEdit} path=":id/edit" />
    </Route>
    <Route component={SignIn} path="sign_in" />
    <Route component={SignOut} path="sign_out" />
    <Route component={SignUp} path="sign_up" />
    <Route component={Tools} path="tools">
      <IndexRoute component={ToolsList} />
      <Route component={ToolNew} path="new" />
      <Route component={ToolView} path=":id" />
      <Route component={ToolDelete} path=":id/delete" />
      <Route component={ToolEdit} path=":id/edit" />
    </Route>
    <Route component={NotFound} isNotFound path="*" />
  </Route>
)
