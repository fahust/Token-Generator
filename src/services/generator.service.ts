import { CreateMetadataDto } from "@/dtos/metadata.dto";
import { HttpException } from "@exceptions/HttpException";
import { User } from "@interfaces/users.interface";
import userModel from "@models/users.model";
import { writeFile } from "node:fs/promises";
import path from "path";

class GeneratorService {
  public async randomValue(trait) {
    const rnd = Math.random() * 100000;

    const percent = rnd / 1000;

    let result = null,
      acc = 0,
      total = 0;

    Object.keys(trait).forEach(key => {
      const floatValue = parseFloat(trait[key]);
      total += floatValue;
      if (result === null && percent > 100 - floatValue - acc) result = key;
      acc += floatValue;
    });
    if (total != 100) throw new Error("Unexpected total percentage");
    return result;
  }

  public async generateAttribute(attributes) {
    const traits = Object.assign({}, attributes);
    for (let index = 0; index < Object.keys(attributes).length; index++) {
      traits[Object.keys(attributes)[index]] = await this.randomValue(
        attributes[Object.keys(attributes)[index]],
      );
    }
    return traits;
  }

  public async generateMetadata(metadata: CreateMetadataDto) {
    return {
      ...metadata,
      attributes: await this.generateAttribute(metadata.attributes),
    };
  }

  public async generateTokens(
    quantity: number,
    metadata: CreateMetadataDto,
  ): Promise<[CreateMetadataDto]> {
    const tokens = [];
    for (let i = 0; i < quantity; ++i) {
      tokens.push(this.generateMetadata(metadata));
    }
    return Promise.all(tokens)
      .then((results: [CreateMetadataDto]) => {
        return results;
      })
      .catch(e => {
        throw new Error(e);
      });
  }

  public async writeJson(tokens: [CreateMetadataDto]) {
    const files = [];

    for (let i = 0; i < tokens.length; ++i) {
      files.push(writeFile(__dirname+"/../../files/tokens/" + i + ".json", JSON.stringify(tokens[i])));
    }
    return Promise.all(tokens)
      .then(results => {
        return results;
      })
      .catch(e => {
        throw new Error(e);
      });
  }
}

export default GeneratorService;
