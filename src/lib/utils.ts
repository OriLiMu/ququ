import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

// 将常见中文标点转换为英文标点
export function normalizeToEnglishPunctuation(text: string): string {
  if (!text) return text;
  const replacements: Record<string, string> = {
    '，': ',',
    '。': '.',
    '？': '?',
    '！': '!',
    '：': ':',
    '；': ';',
    '（': '(',
    '）': ')',
    '【': '[',
    '】': ']',
    '《': '<',
    '》': '>',
    '“': '"',
    '”': '"',
    '‘': "'",
    '’': "'",
    '、': ',',
    '…': '...',
    '—': '-',
    '～': '~',
    '．': '.',
  };
  let result = text;
  for (const [k, v] of Object.entries(replacements)) {
    result = result.split(k).join(v);
  }
  return result;
}