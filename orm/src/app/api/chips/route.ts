import prisma from '../../../../prisma/client'

export const dynamic = 'force-dynamic'

export async function GET() {
  return new Response(JSON.stringify(await prisma.chips.findMany()))
}
