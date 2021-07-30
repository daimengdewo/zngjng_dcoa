var DataTypes = require("sequelize").DataTypes;
var _auth_group = require("./auth_group");
var _auth_group_permissions = require("./auth_group_permissions");
var _auth_permission = require("./auth_permission");
var _authtoken_token = require("./authtoken_token");
var _common_mouldlist = require("./common_mouldlist");
var _django_admin_log = require("./django_admin_log");
var _django_content_type = require("./django_content_type");
var _django_migrations = require("./django_migrations");
var _django_session = require("./django_session");
var _face = require("./face");
var _guize = require("./guize");
var _jingwei = require("./jingwei");
var _kaoqin = require("./kaoqin");
var _zjsys_user = require("./zjsys_user");
var _zjsys_user_groups = require("./zjsys_user_groups");
var _zjsys_user_user_permissions = require("./zjsys_user_user_permissions");

function initModels(sequelize) {
  var auth_group = _auth_group(sequelize, DataTypes);
  var auth_group_permissions = _auth_group_permissions(sequelize, DataTypes);
  var auth_permission = _auth_permission(sequelize, DataTypes);
  var authtoken_token = _authtoken_token(sequelize, DataTypes);
  var common_mouldlist = _common_mouldlist(sequelize, DataTypes);
  var django_admin_log = _django_admin_log(sequelize, DataTypes);
  var django_content_type = _django_content_type(sequelize, DataTypes);
  var django_migrations = _django_migrations(sequelize, DataTypes);
  var django_session = _django_session(sequelize, DataTypes);
  var face = _face(sequelize, DataTypes);
  var guize = _guize(sequelize, DataTypes);
  var jingwei = _jingwei(sequelize, DataTypes);
  var kaoqin = _kaoqin(sequelize, DataTypes);
  var zjsys_user = _zjsys_user(sequelize, DataTypes);
  var zjsys_user_groups = _zjsys_user_groups(sequelize, DataTypes);
  var zjsys_user_user_permissions = _zjsys_user_user_permissions(sequelize, DataTypes);

  auth_group_permissions.belongsTo(auth_group, { as: "group", foreignKey: "group_id"});
  auth_group.hasMany(auth_group_permissions, { as: "auth_group_permissions", foreignKey: "group_id"});
  zjsys_user_groups.belongsTo(auth_group, { as: "group", foreignKey: "group_id"});
  auth_group.hasMany(zjsys_user_groups, { as: "zjsys_user_groups", foreignKey: "group_id"});
  auth_group_permissions.belongsTo(auth_permission, { as: "permission", foreignKey: "permission_id"});
  auth_permission.hasMany(auth_group_permissions, { as: "auth_group_permissions", foreignKey: "permission_id"});
  zjsys_user_user_permissions.belongsTo(auth_permission, { as: "permission", foreignKey: "permission_id"});
  auth_permission.hasMany(zjsys_user_user_permissions, { as: "zjsys_user_user_permissions", foreignKey: "permission_id"});
  auth_permission.belongsTo(django_content_type, { as: "content_type", foreignKey: "content_type_id"});
  django_content_type.hasMany(auth_permission, { as: "auth_permissions", foreignKey: "content_type_id"});
  django_admin_log.belongsTo(django_content_type, { as: "content_type", foreignKey: "content_type_id"});
  django_content_type.hasMany(django_admin_log, { as: "django_admin_logs", foreignKey: "content_type_id"});
  authtoken_token.belongsTo(zjsys_user, { as: "user", foreignKey: "user_id"});
  zjsys_user.hasOne(authtoken_token, { as: "authtoken_token", foreignKey: "user_id"});
  common_mouldlist.belongsTo(zjsys_user, { as: "username", foreignKey: "username_id"});
  zjsys_user.hasMany(common_mouldlist, { as: "common_mouldlists", foreignKey: "username_id"});
  django_admin_log.belongsTo(zjsys_user, { as: "user", foreignKey: "user_id"});
  zjsys_user.hasMany(django_admin_log, { as: "django_admin_logs", foreignKey: "user_id"});
  zjsys_user_groups.belongsTo(zjsys_user, { as: "user", foreignKey: "user_id"});
  zjsys_user.hasMany(zjsys_user_groups, { as: "zjsys_user_groups", foreignKey: "user_id"});
  zjsys_user_user_permissions.belongsTo(zjsys_user, { as: "user", foreignKey: "user_id"});
  zjsys_user.hasMany(zjsys_user_user_permissions, { as: "zjsys_user_user_permissions", foreignKey: "user_id"});

  return {
    auth_group,
    auth_group_permissions,
    auth_permission,
    authtoken_token,
    common_mouldlist,
    django_admin_log,
    django_content_type,
    django_migrations,
    django_session,
    face,
    guize,
    jingwei,
    kaoqin,
    zjsys_user,
    zjsys_user_groups,
    zjsys_user_user_permissions,
  };
}
module.exports = initModels;
module.exports.initModels = initModels;
module.exports.default = initModels;
