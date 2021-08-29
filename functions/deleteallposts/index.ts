import { AzureFunction, Context, HttpRequest } from "@azure/functions"
import * as GhostAdminAPI from '@tryghost/admin-api';
import * as process from 'process';

const GHOST_URL = process.env["GHOST_URL"];
const GHOST_ADMIN_KEY = process.env["GHOST_ADMIN_KEY"];

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
    context.log('HTTP trigger function processed a request.');
    context.log(GHOST_URL);
    context.log(GHOST_ADMIN_KEY);

    const api = new GhostAdminAPI({
        url: GHOST_URL,
        version: "v3",
        key: GHOST_ADMIN_KEY
    });

    const post = api.posts.browse({limit: 900, include: 'title,id'})
        .then((posts: any) => {
            posts.forEach((post: any) => {
                api.posts.delete({ id: post.id })
                    .then(() => {
                        context.log(`deleted: ${post.title}`)
                    })
                    .then(() => {
                        context.res = {
                            status: 200
                        };
                    })
                    .catch((err: any) => {
                        context.res = {
                            status: 500,
                            body: err
                        };
                    });
            });
        })
        .catch((err: any) => {
            context.res = {
                status: 500,
                body: err
            };
        });
};

export default httpTrigger;