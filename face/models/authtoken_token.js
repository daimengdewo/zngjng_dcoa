const Sequelize = require('sequelize');
module.exports = function(sequelize, DataTypes) {
  return sequelize.define('authtoken_token', {
    key: {
      type: DataTypes.STRING(40),
      allowNull: false,
      primaryKey: true
    },
    created: {
      type: DataTypes.DATE(6),
      allowNull: false
    },
    user_id: {
      type: DataTypes.BIGINT,
      allowNull: false,
      references: {
        model: 'zjsys_user',
        key: 'id'
      },
      unique: "authtoken_token_user_id_35299eff_fk_zjsys_user_id"
    }
  }, {
    sequelize,
    tableName: 'authtoken_token',
    timestamps: false,
    indexes: [
      {
        name: "PRIMARY",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "key" },
        ]
      },
      {
        name: "user_id",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "user_id" },
        ]
      },
    ]
  });
};
