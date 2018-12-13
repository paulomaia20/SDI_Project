// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Using Generics now!  comment and annotate, etc.

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  Cursor c;

  ParticleSystem(PVector position) {
    origin = position.get();
    particles = new ArrayList<Particle>();
    c = new Cursor();
  }

  void addParticle() {
    particles.add(new Particle(origin));
  }

  void addParticle(float x, float y) {
    particles.add(new Particle(new PVector(x, y)));
  }
  
  Particle getParticle(int i) {
    Particle p = particles.get(i);
    return p; 
  }
  
    ArrayList<Particle> getParticleList() {
    return this.particles; 
  }
  
  int getNrParticles() {
    int nParticles = particles.size();
    return nParticles; 
  }

  void run() {
    c.run();

    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i); //<>//
      }
    }    
  }
  

  
  
}
