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


import bodyParser from "body-parser"
import cookieParser from "cookie-parser"
import express from "express"
import session from "express-session"
import path from "path"
import favicon from "serve-favicon"

import config from "../config"
import passport from "./passport"
import handleRender from "./render"


const app = express()
app.set("trust proxy", config.proxy)

const apiRouter = express.Router()
apiRouter.use(bodyParser.json());
apiRouter.post("/sign_up", passport.authenticate("local-signup", {session: false}), function(req, res) {
  res.json(req.user)
});
apiRouter.post("/sign_in", passport.authenticate("local-login", {session: false}), function(req, res) {
  res.json(req.user)
})
apiRouter.post("/sign_out", function(req, res) {
  req.logout()
  res.json({})
})

app.use(favicon(path.resolve(__dirname, "../../public/favicon.ico")))
app.use(express.static(path.resolve(__dirname, "../../public")))
app.use("/api", apiRouter)
app.use(cookieParser())
app.use(session({
  cookie: {
    secure: config.session.cookie.secure,
  },
  name: config.session.name,
  resave: false,
  saveUninitialized: false,
  secret: config.session.secret,
}))
app.use(passport.initialize())
app.use(passport.session())
app.use(handleRender)

const host = config.listen.host
const port = config.listen.port || config.port
app.listen(port, host, () => {
  console.log(`Server listening at http://${host}:${port}/`)
})
