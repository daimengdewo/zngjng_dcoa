const Sequelize = require('sequelize');
module.exports = function(sequelize, DataTypes) {
  return sequelize.define('zjsys_user_user_permissions', {
    id: {
      autoIncrement: true,
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    user_id: {
      type: DataTypes.BIGINT,
      allowNull: false,
      references: {
        model: 'zjsys_user',
        key: 'id'
      }
    },
    permission_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'auth_permission',
        key: 'id'
      }
    }
  }, {
    sequelize,
    tableName: 'zjsys_user_user_permissions',
    timestamps: false,
    indexes: [
      {
        name: "PRIMARY",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "id" },
        ]
      },
      {
        name: "zjsys_user_user_permissions_user_id_permission_id_31aecb0a_uniq",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "user_id" },
          { name: "permission_id" },
        ]
      },
      {
        name: "zjsys_user_user_perm_permission_id_76ff7d8d_fk_auth_perm",
        using: "BTREE",
        fields: [
          { name: "permission_id" },
        ]
      },
    ]
  });
};
