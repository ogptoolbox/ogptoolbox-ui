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


import passport from "passport"
import {Strategy as LocalStrategy} from "passport-local"

import {fetchApiJson} from "../fetchers"


// passport.deserializeUser(function (serializedUser, done) {
//   try {
//     done(null, JSON.parse(serializedUser))
//   } catch (e) {
//     done(e)
//   } 
// })

// passport.serializeUser(function (user, done) {
//   try {
//     done(null, JSON.stringify(user))
//   } catch (e) {
//     done(e)
//   } 
// })

passport.use("local-login", new LocalStrategy(
  {
    usernameField: "username",
    passwordField: "password",
  },
  function(username, password, done) {
    fetchApiJson("login", {
      body: JSON.stringify({
        password: password,
        userName: username,
      }),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      method: "post",
    }).then(user => {
      done(null, {
        apiKey: user.apiKey,
        name: user.name,
        urlName: user.urlName,
      })
    }).catch(error => {
      if (error && error.code >= 400 && error.code < 500) {
        done(null, false, {message: error.message})
      }
      else done(error)
    })
  },
))

passport.use("local-signup", new LocalStrategy(
  {
    usernameField: "email",
    passReqToCallback: true,
    passwordField: "password",
  },
  function (req, email, password, done) {
    const username = req.body.username
    fetchApiJson("users", {
      body: JSON.stringify({
        email: email,
        name: username,
        password: password,
        urlName: username,
      }),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      method: "post",
    }).then(user => {
      done(null, {
        apiKey: user.apiKey,
        email: user.email,
        name: user.name,
        urlName: user.urlName,
      })
    }).catch(error => {
      if (error && error.code >= 400 && error.code < 500) {
        done(null, false, {message: error.message})
      }
      else done(error)
    })
  },
))


export default passport