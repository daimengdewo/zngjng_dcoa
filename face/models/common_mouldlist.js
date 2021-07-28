const Sequelize = require('sequelize');
module.exports = function(sequelize, DataTypes) {
  return sequelize.define('common_mouldlist', {
    mouldid: {
      autoIncrement: true,
      type: DataTypes.BIGINT,
      allowNull: false,
      primaryKey: true
    },
    mouldname: {
      type: DataTypes.STRING(50),
      allowNull: false
    },
    mouldjson: {
      type: DataTypes.TEXT,
      allowNull: false
    },
    create_date: {
      type: DataTypes.STRING(20),
      allowNull: false
    },
    username_id: {
      type: DataTypes.STRING(150),
      allowNull: false,
      references: {
        model: 'zjsys_user',
        key: 'username'
      }
    }
  }, {
    sequelize,
    tableName: 'common_mouldlist',
    timestamps: false,
    indexes: [
      {
        name: "PRIMARY",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "mouldid" },
        ]
      },
      {
        name: "common_mouldlist_username_id_c4bdb0aa_fk_zjsys_user_username",
        using: "BTREE",
        fields: [
          { name: "username_id" },
        ]
      },
    ]
  });
};
