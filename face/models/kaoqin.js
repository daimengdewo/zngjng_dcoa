const Sequelize = require('sequelize');
module.exports = function(sequelize, DataTypes) {
  return sequelize.define('kaoqin', {
    ID: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    device: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    name: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    nbr: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    date: {
      type: DataTypes.DATEONLY,
      allowNull: true
    },
    time: {
      type: DataTypes.TIME,
      allowNull: true
    },
    BM: {
      type: DataTypes.STRING(50),
      allowNull: true
    },
    type: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    deviceno: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    datetime: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    direction: {
      type: DataTypes.STRING(255),
      allowNull: true
    },
    nid: {
      autoIncrement: true,
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    }
  }, {
    sequelize,
    tableName: 'kaoqin',
    timestamps: false,
    indexes: [
      {
        name: "PRIMARY",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "nid" },
        ]
      },
    ]
  });
};
