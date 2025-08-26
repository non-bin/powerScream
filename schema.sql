DROP TABLE IF EXISTS Comments;
DROP TABLE IF EXISTS RouteAttempts;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS RouteImages;
DROP TABLE IF EXISTS AreaImages;
DROP TABLE IF EXISTS PolygonPoints;
DROP TABLE IF EXISTS Polygons;
DROP TABLE IF EXISTS Routes;
DROP TABLE IF EXISTS Areas;
DROP TABLE IF EXISTS RouteTypes;
DROP TABLE IF EXISTS AreaTypes;

-- Should not be modified
CREATE TABLE AreaTypes (
  ID INTEGER PRIMARY KEY
  Name TEXT NOT NULL,
  Description TEXT NOT NULL
);

INSERT INTO AreaTypes (ID, Name, Description) VALUES
  (0, 'Gym', 'Indoor climbing space, maintained and reset often'),
  (1, 'Field', 'Outdoor area with known good climbs, usually unmaintained and static');

-- Should not be modified
CREATE TABLE RouteTypes (
  ID INTEGER PRIMARY KEY
  Name TEXT NOT NULL,
  Description TEXT NOT NULL
);

INSERT INTO RouteTypes (ID, Name, Description) VALUES
  (0, 'Boulder', 'Performed on small rock formations or artificial rock walls without the use of ropes or harnesses'),
  (1, 'Top rope', 'The climber is securely attached to a climbing rope that runs through a fixed anchor at the top of the climbing route, and back down to the belayer at the base of the climb'),
  (2, 'Trad', 'Free climbing, where the climber places temporary and removable protection while simultaneously ascending the route'),
  (3, 'Lead', 'Technique in climbing in which a climber uses a rope for safety but the rope is not pre-attached to the top of the climb, they must instead attach their rope to permanent protection as they ascend'),
  (4, 'Free solo', 'Climbing solo and without ropes or any form of protective equipment');

CREATE TABLE Areas (
  Parent REFERENCES Areas(ID),
  ID INTEGER PRIMARY KEY,
  Type REFERENCES AreaTypes(ID) NOT NULL,
  Lat REAL NOT NULL,
  Lon REAL NOT NULL,
  Name TEXT NOT NULL,
  Description TEXT,
  Link TEXT,
  Colour TEXT
);

CREATE TABLE Routes (
  Parent REFERENCES Routes(ID),
  Area REFERENCES Areas(ID) NOT NULL,
  ID INTEGER PRIMARY KEY,
  Type REFERENCES RouteTypes(ID) NOT NULL,
  Lat REAL NOT NULL,
  Lon REAL NOT NULL,
  Name TEXT NOT NULL,
  Description TEXT,
  Rules TEXT,
  Link TEXT,
  Colour TEXT,
  CreatorGrade TEXT,
);

-- Look into geopoly
CREATE TABLE Polygons (
  ID INTEGER PRIMARY KEY,
  Area REFERENCES Areas(ID) NOT NULL
);

CREATE TABLE PolygonPoints (
  SeqNum INTEGER,
  Poly REFERENCES Polygons(ID),
  PRIMARY KEY (SeqNum, PolyID),

  Lat REAL NOT NULL,
  Lon REAL NOT NULL
);

CREATE TABLE AreaImages (
  Area REFERENCES Areas(ID) NOT NULL,
  Link TEXT NOT NULL,
  Name TEXT,
  Description TEXT,

  Lat1 REAL,
  Lon1 REAL,
  Lat2 REAL,
  Lon2 REAL,
  CHECK (
    (Lat1 IS NULL AND Lon1 IS NULL AND Lat2 IS NULL Lon2 IS NULL) OR
    (Lat1 IS NOT NULL AND Lon1 IS NOT NULL AND Lat2 IS NOT NULL Lon2 IS NOT NULL)
  )
);

CREATE TABLE RouteImages (
  Route REFERENCES Routes(ID) NOT NULL,
  Link TEXT NOT NULL,
  Name TEXT,
  Description TEXT,
);

CREATE TABLE Users (
  ID INTEGER PRIMARY KEY,
  Email TEXT NOT NULL,
  Name TEXT NOT NULL,
  Password TEXT NOT NULL
);

CREATE TABLE RouteAttempts (
  Route REFERENCES Route(ID),
  User REFERENCES Users(ID),
  Timestamp DATETIME,
  PRIMARY KEY (Route, User, Timestamp)

  Topped BOOLEAN NOT NULL,
);

CREATE TABLE Comments (
  ID INTEGER PRIMARY KEY,
  Parent REFERENCES Comments(ID),

  Route REFERENCES Routes(ID),
  Area REFERENCES Areas(ID),

  Grade TEXT,
  Stars INTEGER,
  Comment TEXT,
  User REFERENCES Users(ID),
  UserGrade
  Timestamp

  CHECK (
    (Route IS NOT NULL AND Area IS NULL) OR
    (Area IS NOT NULL AND Route IS NULL)
  ),
);
