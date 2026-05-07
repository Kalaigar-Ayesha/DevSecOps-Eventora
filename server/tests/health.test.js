const request = require('supertest');
const mongoose = require('mongoose');
const app = require('../server'); // Import the app without starting the server

describe('GET /health', () => {
  afterAll(async () => {
    // Close the mongoose connection after the test to prevent Jest from hanging
    await mongoose.connection.close();
  });

  it('should return 200 OK and status ok', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
    expect(response.body).toEqual({ status: 'ok' });
  });
});
