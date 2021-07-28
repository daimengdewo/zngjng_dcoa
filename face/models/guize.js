const Sequelize = require('sequelize');
module.exports = function(sequelize, DataTypes) {
  return sequelize.define('guize', {
    BM: {
      type: DataTypes.STRING(50),
      allowNull: true,
      unique: "1"
    },
    content: {
      type: DataTypes.JSON,
      allowNull: true
    },
    BMid: {
      autoIncrement: true,
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    }
  }, {
    sequelize,
    tableName: 'guize',
    timestamps: false,
    indexes: [
      {
        name: "1",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "BM" },
        ]
      },
      {
        name: "PRIMARY",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "BMid" },
        ]
      },
    ]
  });
};
