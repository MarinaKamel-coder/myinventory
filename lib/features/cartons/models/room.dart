enum Room {
  salon('Salon'),
  cuisine('Cuisine'),
  chambre('Chambre'),
  salleDeBain('Salle de bain'),
  bureau('Bureau'),
  garage('Garage'),
  cave('Cave'),
  autre('Autre');

  const Room(this.label);

  final String label;
}
