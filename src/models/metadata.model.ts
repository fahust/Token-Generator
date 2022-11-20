import { model, Schema, Document } from "mongoose";
import { Metadata } from "@interfaces/metadata.interface";

const metadataSchema: Schema = new Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    description: {
      type: String,
      required: true,
      trim: true,
    },
    image: {
      type: String,
      required: true,
      trim: true,
    },
    edition: {
      type: String,
      required: true,
      trim: true,
    },
    collection: {
      type: Object,
      required: true,
    },
    symbol: {
      type: String,
      required: true,
      trim: true,
    },
    properties: {
      type: Object,
      required: true,
      trim: true,
    },
    category: {
      type: String,
      required: true,
      trim: true,
    },
    creators: {
      type: String,
      required: true,
      trim: true,
    },
    attributes: {
      type: Object,
      required: true,
      trim: true,
    },
  },
  {
    timestamps: true,
  },
);

const metadataModel = model<Metadata & Document>("Metadata", metadataSchema);

export default metadataModel;
