export interface Metadata {
  name: string;
  description: string;
  image: string;
  edition: string;
  collection: Collection;
  symbol: string;
  properties: Properties;
  category: string;
  creators: string;
  attributes: Record<string, Record<string, string>>;
}

export interface Properties {
  files: [Files];
}

export interface Files {
  uri: string;
  type: string;
}

export interface Collection {
  nameCollection: string;
}
