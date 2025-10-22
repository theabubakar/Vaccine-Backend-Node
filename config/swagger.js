const swaggerJSDoc = require('swagger-jsdoc');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Vaccine Management System API',
      version: '1.0.0',
      description: 'A comprehensive API for managing vaccines and doses in a healthcare system',
      contact: {
        name: 'API Support',
        email: 'support@vaccinemanagement.com'
      },
      license: {
        name: 'MIT',
        url: 'https://opensource.org/licenses/MIT'
      }
    },
    servers: [
      {
        url: 'http://localhost:3000',
        description: 'Development server'
      }
    ],
    components: {
      schemas: {
        Vaccine: {
          type: 'object',
          required: ['vaccineID', 'name', 'minAge', 'maxAge'],
          properties: {
            _id: {
              type: 'string',
              description: 'Auto-generated unique identifier'
            },
            vaccineID: {
              type: 'string',
              description: 'Unique identifier for the vaccine',
              example: 'VAC001'
            },
            name: {
              type: 'string',
              description: 'Name of the vaccine',
              example: 'COVID-19 Vaccine'
            },
            minAge: {
              type: 'number',
              description: 'Minimum age for vaccination',
              example: 18
            },
            maxAge: {
              type: 'number',
              description: 'Maximum age for vaccination',
              example: 100
            },
            isInfinite: {
              type: 'boolean',
              description: 'Whether the vaccine has infinite validity',
              default: false
            },
            validity: {
              type: 'boolean',
              description: 'Current validity status',
              default: true
            },
            createdAt: {
              type: 'string',
              format: 'date-time',
              description: 'Creation timestamp'
            },
            updatedAt: {
              type: 'string',
              format: 'date-time',
              description: 'Last update timestamp'
            }
          }
        },
        Dose: {
          type: 'object',
          required: ['doseId', 'minAge', 'maxAge', 'vaccineID'],
          properties: {
            _id: {
              type: 'string',
              description: 'Auto-generated unique identifier'
            },
            doseId: {
              type: 'string',
              description: 'Unique identifier for the dose',
              example: 'DOSE001'
            },
            minAge: {
              type: 'number',
              description: 'Minimum age for this dose',
              example: 18
            },
            maxAge: {
              type: 'number',
              description: 'Maximum age for this dose',
              example: 100
            },
            minGap: {
              type: 'number',
              description: 'Minimum gap between doses in days',
              default: 0,
              example: 28
            },
            vaccineID: {
              type: 'string',
              description: 'Reference to Vaccine collection',
              example: 'VAC001'
            },
            vaccine: {
              $ref: '#/components/schemas/Vaccine',
              description: 'Populated vaccine information'
            },
            createdAt: {
              type: 'string',
              format: 'date-time',
              description: 'Creation timestamp'
            },
            updatedAt: {
              type: 'string',
              format: 'date-time',
              description: 'Last update timestamp'
            }
          }
        },
        Error: {
          type: 'object',
          properties: {
            success: {
              type: 'boolean',
              example: false
            },
            message: {
              type: 'string',
              example: 'Error message'
            },
            error: {
              type: 'string',
              example: 'Detailed error information'
            }
          }
        },
        Success: {
          type: 'object',
          properties: {
            success: {
              type: 'boolean',
              example: true
            },
            message: {
              type: 'string',
              example: 'Operation successful'
            },
            data: {
              type: 'object',
              description: 'Response data'
            }
          }
        }
      }
    }
  },
  apis: ['./routes/*.js', './server.js']
};

const specs = swaggerJSDoc(options);

module.exports = specs;
