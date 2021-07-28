const Sequelize = require('sequelize');
module.exports = function(sequelize, DataTypes) {
  return sequelize.define('django_session', {
    session_key: {
      type: DataTypes.STRING(40),
      allowNull: false,
      primaryKey: true
    },
    session_data: {
      type: DataTypes.TEXT,
      allowNull: false
    },
    expire_date: {
      type: DataTypes.DATE(6),
      allowNull: false
    }
  }, {
    sequelize,
    tableName: 'django_session',
    timestamps: false,
    indexes: [
      {
        name: "PRIMARY",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "session_key" },
        ]
      },
      {
        name: "django_session_expire_date_a5c62663",
        using: "BTREE",
        fields: [
          { name: "expire_date" },
        ]
      },
    ]
  });
};
